module Hyde
  module TemplateHelper
    def notice(new_notice = nil)
      @notice = new_notice unless new_notice.nil?
      @notice
    end
  end
end
