# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::CardComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(game: create(:item), current_user: create(:user))) }

  it 'renders without problems' do
    expect(rendered.to_html).to be_present
  end
end
