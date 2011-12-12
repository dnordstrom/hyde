module Hyde
  module TemplateHelper
    def notice(new_notice = nil)
      # If using symbol argument, we provide some
      # predefined status messages.
      if new_notice.is_a? Symbol
        @notice = "Successfully saved your file." if new_notice === :success
      else
        @notice = new_notice unless new_notice.nil?
      end
      
      @notice
    end
  end
end
