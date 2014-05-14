require 'spec_helper'

describe ApplicationHelper do
  describe '#content_tag_with_conditional_classes' do
    it 'displays classes based on boolean' do
      attributes = { class_names: { assigned: false, active: true } }
      result = content_tag_with_conditional_classes(:li, attributes) do
        'content'
      end

      expect(result).to have_css('li.active', text: 'content')
      expect(result).not_to have_css('.assigned')
    end
  end
end
