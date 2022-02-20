require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"
require "byebug"

class App
  def initialize
    @state = Model::initial_state
  end

  def start
    @view = View::Ruby2dView.new(self)
    #Ruby2D utiliza el thread principal para ejecutar la ventana, por lo que debemos utilizar un thead aducional
    timer_thread = Thread.new { init_timer(@view) }
    @view.start(@state)
    timer_thread.join
  end

  def init_timer(view)
    loop do
      if @state.game_finished
        puts "Juego terminado"
        puts "Puntaje: #{@state.snake.positions.length}"
        break
      end
      #trigger movement
      @state = Actions::move_snake(@state)
      @view.renderAction(@state)
      sleep 0.5
    end
  end

  def send_acction(action, params)
    new_state = Actions.send(action, @state, params)
    #verificamo con .hash si el estado ha cambiado, para no hacer renders innecesarios
    if new_state.hash != @state
      @state = new_state
      @view.renderAction(@state)
    end
  end
end

app = App.new
app.start

#view = View::Ruby2dView.new
#state = Model::initial_state
#view.start(state)
#view.renderAction(state)
