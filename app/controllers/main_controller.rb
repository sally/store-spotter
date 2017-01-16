class MainController

  def run
    MainViewer.welcome
    get_store
  end

  private

  def get_store
    user_input = MainViewer.ask_address.downcase

    if user_input == "exit"
      MainViewer.bye
    else
      get_store
    end
  end
  
end
