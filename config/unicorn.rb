@app_dir = File.absolute_path('..', File.dirname(__FILE__))

worker_processes 2
working_directory @app_dir

timeout 30

listen "#{@app_dir}/tmp/sockets/unicorn.sock", backlog: 64

pid "#{@app_dir}/tmp/pids/unicorn.pid"

stderr_path "#{@app_dir}/tmp/logs/unicorn.stderr.log"
stdout_path "#{@app_dir}/tmp/logs/unicorn.stdout.log"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end
