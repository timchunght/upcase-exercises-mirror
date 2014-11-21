class BackgroundService
  pattr_initialize [:service, :method_name, :data]

  def perform
    p "#{service.class.name}##{method_name}"
    NewRelic::Agent.set_transaction_name("#{service.class.name}##{method_name}")
    service.send(method_name, *data)
  end

  def error(job, exception)
    dependencies[:error_notifier].notify(exception)
  end

  private

  def dependencies
    Payload::RailsLoader.load
  end
end
