class HelloJob
  @queue = :hello

  def self.perform(name)
    puts "Hello #{name}!"
    sleep 10
    puts "Goodbye #{name}"
  end
end