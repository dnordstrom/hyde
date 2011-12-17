module Hyde
  class Setup
    # We don't need an instance for these setup tasks, can define
    # them on the class' eigenclass.
    class << self
      def templates_dir
        File.join(File.expand_path( File.dirname(__FILE__) ), "../hyde/templates")
      end

      def hyde_dir
        File.join( Dir.pwd, "hyde" )
      end

      # Creates a hyde/ directory in the current working directory
      # unless it already exits.
      def create_hyde_dir
        templates_dir = Dir.pwd + "/hyde"

        unless File.directory? hyde_dir
          Dir.mkdir hyde_dir
        end
      end

      # Copies configuration file template to hyde/ directory.
      def configure(opts)
        filename = opts[:configure].gsub(".", "_") + ".rb"
        template = templates_dir + "/config.rb"
        destination = File.join(Dir.pwd, "hyde", filename)

        create_hyde_dir

        FileUtils.cp(template, destination)

        exit
      end

      # Copies rackup script to hyde/ directory.
      def rackup(opts)
        template = templates_dir + "/rackup.rb"
        destination = File.join(Dir.pwd, "hyde/config.ru")

        create_hyde_dir

        FileUtils.cp(template, destination)

        exit
      end
    end
  end
end
