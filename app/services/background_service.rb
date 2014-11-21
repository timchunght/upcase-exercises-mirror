class BackgroundService
  pattr_initialize [:service, :method_name, :data]

  def perform
    NewRelic::Agent.set_transaction_name("#{service.class.name}##{method_name}")
    service.send(method_name, *data)
  end

  def error(_job, exception)
    dependencies[:error_notifier].notify(exception)
  end

  private

  def dependencies
    Payload::RailsLoader.load
  end
end
