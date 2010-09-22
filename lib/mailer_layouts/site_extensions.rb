module ShareLayouts::SiteExtensions

  def self.included(base)
    base.class_eval {
      belongs_to :default_layout, :class_name => "Layout"
    }
  end

  def layout_for(area = :public)
    if self.respond_to?("#{area}_layout") && associated_layout = self.send("#{area}_layout".intern)
      associated_layout.name
    elsif configured_layout = Layout.find_by_name(Radiant::Config["#{area}.layout"])
      configured_layout.name
    elsif named_layout = Layout.find_by_name(area.to_s)
      named_layout.name
    elsif default_layout = self.default_layout
      default_layout.name
    elsif any_layout = Layout.first
      any_layout.name
    end
  end

end

