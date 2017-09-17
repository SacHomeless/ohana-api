## Making Backups

I've been using the simple approach:

```bash
sudo -u postgres pg_dump -C -c ohana_api_development > /tmp/backups/<timestamped_filename>
```

The `-C -c` arguments tell pg_dump to add commands to the final dump file to clear and drop the database before reloading it.

I've wrapped the above step along with a line to save the 
result on my local machine in a very simple Ruby script:

```ruby
#!/usr/bin/env ruby

filename = "ohana_api_development_#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
puts "Dumping the database"
`ssh sacsos "cd /tmp && mkdir -p /tmp/backups && sudo -u postgres pg_dump -C -c ohana_api_development > /tmp/backups/#{filename}"`

puts "Fetching the dumps"
`rsync -auvx sacsos:/tmp/backups .`
```


## Restoring backups

I've restored the dump file into postgres running in docker
on my development machine.

First, mount the directory containing the backup into
the postgres container.

Then, in the docker postgresql container:

```bash
sudo postgres psql < dump_file
```
