module Hyde
  module TemplateHelper
    def notice(new_notice = nil)
      new_notice.nil? ? @notice : @notice = new_notice
    end
  end
end
