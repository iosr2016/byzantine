class InstanceRunner
  def initialize(instances)
    @instances = instances
  end

  def start
    @pids = start_instances
    sleep 1 # TODO: improve instance readiness check
  end

  def stop
    stop_instances
  end

  private

  attr_reader :instances, :pids

  def start_instances
    instances.map do |instance|
      Process.fork { instance.run }
    end
  end

  def stop_instances
    pids.each { |pid| Process.kill 'QUIT', pid }
    Process.waitall
  end
end
