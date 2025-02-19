# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, only: %i[wishlist]

  def index
    list_games
  end

  def on_sale
    list_games(on_sale: true)
  end

  def new_releases
    list_games(new_release: true)
  end

  def coming_soon
    list_games(coming_soon: true)
  end

  def pre_order
    list_games(pre_order: true)
  end

  def wishlist
    list_games(wishlisted: true)
  end

  def show
    result = Items::Find.result(slug: params[:slug], user: current_user)

    @game = result.item
  end

  private

  def list_games(filter_overrides = {})
    result = Items::List.result(
      filters_form: filters_form(filter_overrides),
      sort_param: sort_param || 'all_time_visits_desc',
      user: current_user
    )

    @pagy, @games = pagy(result.items)
  end

  def filters_form(overrides)
    @filters_form ||= GameFiltersForm.build(permitted_params[:q].to_h.merge(overrides))
  end

  def sort_param
    permitted_params[:sort].to_s.presence
  end

  def permitted_params
    params.permit(:sort, q: GameFiltersForm.attribute_names)
  end
end
