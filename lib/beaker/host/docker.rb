[ 'host', 'command_factory', 'command', 'options' ].each do |lib|
  require "beaker/#{lib}"
end

require "beaker/host/unix"

module Docker
  class Host < Unix::Host
    def connection
      @connection ||= Beaker::DockerConnection.connect( {:docker_container => self['docker_container'] } )
    end

    def close
    end

    def do_docker_cp_to from_path, to_path, opts = {}
      container.exec(["bash", "-c", "tar x -C #{to_path}"], stdin: StringIO.new(`tar -cv #{from_path}`))
    end
  end
end

