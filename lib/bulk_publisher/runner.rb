require "bulk_publisher/version"
require "usazi_util/runner"

class BulkPublisher::Runner < Thor
  include UsaziUtil::Runner
  $0 = "BulkPublisher - #{::BulkPublisher::Version::STRING}"

  desc "start", "Run the bulk_publisher"
  option :message_count,                  type: :numeric, aliases: '-m', desc: "message count that number of per thread"
  option :connection_count,   default: 5, type: :numeric, aliases: '-c', desc: "connection count"
  option :pid_file,                       type: :string,  aliases: '-P', desc: "pid file name."
  def start
    super()
  end

private
  def class_name
    "bulk_publisher"
  end
end


