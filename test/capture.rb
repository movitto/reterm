#!/usr/bin/ruby

require 'fileutils'
require 'open3'

TIMEOUT = 0.3

EXAMPLE_DIR  = File.expand_path(File.join(File.dirname(__FILE__), "..", "examples"))
CRITERIA_DIR = File.expand_path(File.join(File.dirname(__FILE__), "criteria"))
VERIFY_DIR   = File.expand_path(File.join(File.dirname(__FILE__), "verify"))


def capture_to(dir)
  Dir.glob("#{EXAMPLE_DIR}/**/*.rb").each { |example|
    rout, wout = IO.pipe
    rerr, werr = IO.pipe

    pid = Process.spawn("/usr/bin/ruby #{example}", :out => wout, :err => werr)

    Thread.new {
      sleep(TIMEOUT)
      Process.kill(9, pid)
    }

    _, status = Process.wait2(pid)

    # close write ends so we could read them
    wout.close
    werr.close

    stdout = rout.readlines.join("\n")
    stderr = rerr.readlines.join("\n")

    # dispose the read ends of the pipes
    rout.close
    rerr.close

    File.write "#{dir}/#{example.split("/").last}", stdout
  }
end

def verify
  FileUtils.rm_rf VERIFY_DIR
  FileUtils.mkdir VERIFY_DIR

  capture_to(VERIFY_DIR)

  Dir.glob("#{VERIFY_DIR}/**/*.rb").each { |example|
    criteria_file = File.join(CRITERIA_DIR, example.split("/").last)
    criteria = File.read(criteria_file)
    verify = File.read(example)

    if criteria != verify
      puts "MISMATCH in #{example}"
    end
  }
end

verify
