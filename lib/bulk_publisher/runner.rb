require "thor"
require "yaml"
require "bulk_publisher/version"

class BulkPublisher::Runner < Thor
  $0 = "BulkPublisher - #{::BulkPublisher::Version::STRING}"

  desc "start", "Run the bulk_publisher"
  option :daemonize,                      type: :boolean, aliases: '-d', desc: "Running as a daemon"
  option :message_count,                  type: :numeric, aliases: '-m', desc: "message count that number of per thread"
  option :connection_count,   default: 5, type: :numeric, aliases: '-c', desc: "connection count"
  option :pid_file,                       type: :string,  aliases: '-P', desc: "pid file name."
  option :queue_name,                     type: :string,  aliases: '-Q', desc: "queue name"


  def start
    puts "Starting bulk_publisher process."

    params = get_params( options )

    BulkPublisher::Pid.file = options["pid_file"]

    BulkPublisher::Daemon.new(params).start
  rescue Interrupt #Ctrl+c の処理
    BulkPublisher::Daemon.new(params).stop
  end

  private

  def get_params( options )
    @params ||= {}
    BulkPublisher::OPTIOM_KEYS.each { |key|
      set_param!( hash: @params, key: key )
    }

    #環境変数から取得する際にtrue/falseが文字列になるので変換
    case @params["ssl"]
    when "true"; @params["ssl"] = true
    when "false"; @params["ssl"] = false
    end

    if options
      @params["connection_count"] = options["connection_count"]
      @params["message_count"] = options["message_count"]
      @params["queue_name"] = options["queue_name"]
    end
    @params
  end

  def set_param!( hash:, key: )
    env_key = BulkPublisher::ENVIRONMENT[key]
    hash[key] = ENV[env_key] if env_key
    hash
  end
end
