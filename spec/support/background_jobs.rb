module BackgroundJobs
  def run_background_jobs_immediately
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
    yield
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end

  def pause_background_jobs
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = true
    yield
    Delayed::Worker.new.work_off
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    run_background_jobs_immediately do
      example.run
    end
  end

  config.include BackgroundJobs
end
