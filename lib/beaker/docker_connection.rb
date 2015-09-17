module Beaker
  class DockerConnection

    def initialize name_hash
      @container = name_hash[:docker_container]
      @logger = options[:logger]
    end

    def self.connect name_hash
      new name_hash
    end

    def close
      @logger.debug("In close method")
    end

    def execute command, options = {}, stdout_callback = nil,
                stderr_callback = stdout_callback

      result = Result.new(@hostname, command)
      return result if options[:dry_run]

      stdout, stderr, exit_code = @container.exec(['bash', '-c', command])

      if !stdout.empty?
        data = stdout[0]
        stdout_callback[data] if stdout_callback
        result.stdout << data
        result.output << data
      end

      if !stderr.empty?
        data = stderr[0]
        stderr_callback[data] if stderr_callback
        result.stderr << data
        result.output << data unless exit_code == 0
      end

      result.exit_code = exit_code

      result.finalize!
      @logger.last_result = result
      result
    end
  end
end
