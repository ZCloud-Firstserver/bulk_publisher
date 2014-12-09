class BulkPublisher::Pid
  class << self
    attr_accessor: :file
    def create
      pid = Process.pid
      File.write(file, "#{pid}")
    rescue
      file = nil
      puts "could not create pid file."
    end

    def delete
      if file
        File.unlink( file )
      end
    end
  end
end
