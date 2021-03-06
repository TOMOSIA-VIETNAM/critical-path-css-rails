# frozen_string_literal: true

# NPM wrapper with helpful error messages
class NpmCommands
  # @return [Boolean] whether the installation succeeded
  def install(*args)
    puts "\n================ARGS================\n"
    puts args.inspect
    puts "\n================/ ARGS================\n"

    check_nodejs_installed
    # return false unless check_nodejs_installed
    STDERR.puts 'Installing npm dependencies...'
    install_status = Dir.chdir File.expand_path('..', File.dirname(__FILE__)) do
      system('npm', 'install', *args)
    end
    STDERR.puts(
      *if install_status
         ['npm dependencies installed']
       else
         ['-' * 60,
          'Error: npm dependencies installation failed',
          '-' * 60]
       end
    )
    install_status
  end

  private

  def check_nodejs_installed
    return true if executable?('node')
    STDERR.puts(
      '-' * 60,
      'Error: critical-path-css-rails requires NodeJS and NPM.',
      *if executable?('brew')
         ['  To install NodeJS and NPM, run:',
          '  brew install node']
       elsif Gem.win_platform?
         ['  To install NodeJS and NPM, we recommend:',
          '  https://github.com/coreybutler/nvm-windows/releases']
       else
         ['  To install NodeJS and NPM, we recommend:',
          '  https://github.com/creationix/nvm']
       end,
      '-' * 60
    )
  end

  def executable?(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    puts "\n================PATHEXT================\n"
    puts ENV['PATHEXT']
    puts "\n================/ PATHEXT================\n"

    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    puts "\n================/ PATH: #{path}================\n"

      exts.each do |ext|
        exe = File.join(path, "#{cmd}#{ext}")

        puts "\n================/ CMD: #{cmd} ; #{ext}================\n"

        return exe if File.executable?(exe) && !File.directory?(exe)
      end
    end
    nil
  end
end
