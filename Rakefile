require 'rake'
require 'fileutils'

def dotfiles
  Dir['*'] - ['README.md', 'Rakefile']
end

desc 'Hook our dotfiles into system-standard positions.'
task :install do
  linkables = dotfiles

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last
    target = "#{ENV['HOME']}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      FileUtils.mv(target, "#{target}.backup") if backup || backup_all
      #`mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    FileUtils.ln_s("#{Dir.pwd}/#{linkable}", target)
    #`ln -s "$PWD/#{linkable}" "#{target}"`
  end

  if File.exists?('vim.symlink/bundle/command-t')
    puts "Making Command-T"
    FileUtils.cd 'vim.symlink/bundle/command-t' do
      sh 'bundle && rake make'
    end
  end
end

task :uninstall do
  dotfiles.each do |linkable|

    file = linkable.split('/').last
    target = "#{ENV['HOME']}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end
    
    # Replace any backups made during installation
    backup = "#{target}.backup"
    if File.exists?(backup)
      FileUtils.mv(backup, target)
      #`mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end
  end
end

task :default => :install
