
class VirusKiller
  VIRUS_REG = /<SCRIPT Language=VBScript>[\s\w\W\d.]*<\/SCRIPT>/

  def is_virus?(base, file)
    return unless file
    base_file = File.basename(file).gsub /\.exe/, ''
    ext = File.extname(file)
    b = File.basename(base)

    if ext == '.exe' and base_file == b
      puts "#{file} is dam virus"
      return true
    end
  end

  def fix_html_virus(file)
   return if File.extname(file) != '.html'
   file_content = File.read(file) 
   clean_content = file_content.gsub(VIRUS_REG, '')
   File.open(file, "w") { |new_file| new_file << clean_content }
  end

  def transver_files(base, folder=nil)
    Dir.foreach(base) do |file|
      begin
        next if file == '.' or file == '..' or file == 'tmp'

        if File.file?(base+file)
           uri = base+file
           if is_virus?(base, file)
             File.delete uri
             puts "deleting    #{uri}"
           else
             fix_html_virus uri
           end
          next
        else
          transver_files(base+file+'/')
        end

      rescue Exception => e
        puts e.message
      end
    end
  end

  def run(root_path)
    transver_files root_path
  end
end

VirusKiller.new.run ARGV[0] || '/media/naveed/'
