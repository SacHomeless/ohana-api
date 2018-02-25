class Admin
  class OrganizationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    include Taggable

    def index
      @all_orgs = if params[:search]
                    policy_scope(Organization).where('name ilike ?', '%' + params[:search].to_s + '%')
                  elsif params[:q]
                    policy_scope(Organization).where('name ilike ?', params[:q].to_s + '%')
                  else
                    policy_scope(Organization)
                  end

      respond_to do |format|
        format.html do
          @orgs = Kaminari.paginate_array(@all_orgs.order(:name)).page(params[:page])
        end
        format.json do
          render json: @all_orgs.order(:id).all.collect { |org| org.name =~ /#{params[:q]}/i ? [org.id, org.name, org.description] : nil }.compact
        end
      end
    end

    def edit
      @organization = Organization.find(params[:id])

      authorize @organization
    end

    def update
      @organization = Organization.find(params[:id])

      preprocess_organization_params

      if @organization.update(params[:organization])
        redirect_to [:admin, @organization],
                    notice: 'Organization was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @organization = Organization.new
      authorize @organization
    end

    def create
      preprocess_organization_params

      @organization = Organization.new(params[:organization])

      if @organization.save
        redirect_to admin_organizations_url,
                    notice: 'Organization was successfully created.'
      else
        render :new
      end
    end

    def destroy
      organization = Organization.find(params[:id])
      organization.destroy
      redirect_to admin_organizations_path
    end

    private

    def preprocess_organization_params
      shift_and_split_params(params[:organization], :accreditations, :licenses)
    end
  end
end
