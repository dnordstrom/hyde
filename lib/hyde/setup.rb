module Hyde
  class Setup
    # We don't need an instance for these setup tasks, can define
    # them on the class' eigenclass.
    class << self
      TEMPLATES = File.join( File.expand_path(__FILE__), "../hyde/templates" )
      HYDE = File.join( Dir.pwd, "hyde" )

      # Creates a hyde/ directory in the current working directory
      # unless it already exits.
      def create_hyde_dir
        TEMPLATES = Dir.pwd + "/hyde"

        unless File.directory? HYDE
          Dir.mkdir HYDE
        end
      end

      # Copies configuration file template to hyde/ directory.
      def configure(opts)
        filename = opts[:configure].gsub(".", "_") + ".rb"
        template = TEMPLATES + "/config.rb"
        destination = File.join(Dir.pwd, "hyde", filename)

        create_hyde_dir

        FileUtils.cp(template, destination)

        exit
      end

      # Copies rackup script to hyde/ directory.
      def rackup(opts)
        template = TEMPLATES + "/rackup.rb"
        destination = File.join(Dir.pwd, "hyde/config.ru")

        create_hyde_dir

        FileUtils.cp(template, destination)

        exit
      end
    end
  end
end
