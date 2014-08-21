module JobOwner
  def self.included(base)
    base.has_many :jobs, class_name:Delayed::Job.name, :as => :owner, :dependent => :destroy
  end

  def send_at(time, method, *args)
    Delayed::Job.transaction do
      job = Delayed::Job.enqueue(Delayed::PerformableMethod.new(self, method.to_sym, args),
                                 run_at:time)
      job.owner = self
      job.save
    end
  end

  def send_at_from_queue(queue, time, method, *args)
    Delayed::Job.transaction do
      job = Delayed::Job.enqueue(Delayed::PerformableMethod.new(self, method.to_sym, args),
                                 run_at:time, queue:queue)
      job.owner = self
      job.save
    end
  end

  def clear_queue(queue)
    jobs.where(queue:queue).destroy_all
  end

end