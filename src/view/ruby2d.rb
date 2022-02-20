require "ruby2d"
require_relative "../model/state"
require "byebug"

module View
  class Ruby2dView

    def initialize(app)
      @pixel_size = 50
      @app = app
    end

    def start(state)
      extend Ruby2D::DSL
      set(
        title: "Snake",
        width: @pixel_size * state.grid.cols,
        height: @pixel_size * state.grid.rows
      )
      on :key_down do |event|
        # A key was pressed
        handle_key_event(event)
        puts event.key
        puts "Sergio no deja de ser perra"
      end

      show
    end

    def renderAction(state)
      extend Ruby2D::DSL
      close if state.game_finished
      render_food(state)
      render_snake(state)
    end

    private

    def render_food(state)
      extend Ruby2D::DSL
      @food.remove if @food
      food = state.food
      @food = Square.new(
        x: food.col * @pixel_size,
        y: food.row * @pixel_size,
        size: @pixel_size,
        color: 'yellow'
      )
    end

    def render_snake(state)
      extend Ruby2D::DSL

      #if @snake_positions
      #  @snake_positions.each do |pos|
      #    pos.remove
      #  end
      #end

      #las 5 lineas de código se remplazan por una sola siguiente

      @snake_positions.each(&:remove) if @snake_positions

      snake = state.snake
      @snake_positions = snake.positions.map do |pos|
        Square.new(
          x: pos.col * @pixel_size,
          y: pos.row * @pixel_size,
          size: @pixel_size,
          color: 'red'
        )
      end
    end

    def handle_key_event(event)
      case event.key
      when "up"
        # cambiar dirección hacia arriba
        @app.send_acction(:change_direction, Model::Direction::UP)
      when "down"
        # cambiar dirección hacia abajo
        @app.send_acction(:change_direction, Model::Direction::DOWN)
      when "right"
        # cambiar dirección hacia derecha
        @app.send_acction(:change_direction, Model::Direction::RIGHT)
      when "left"
        # cambiar dirección hacia izquierda
        @app.send_acction(:change_direction, Model::Direction::LEFT)
      end
    end
  end
end
