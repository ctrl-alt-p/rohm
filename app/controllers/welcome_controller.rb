class WelcomeController < ApplicationController
  def index
    render component: 'WelcomeMessage', props: { name: 'User' }, tag: 'span', class: 'todo'
  end
end
