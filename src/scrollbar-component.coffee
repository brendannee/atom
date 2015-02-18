module.exports =
class ScrollbarComponent
  constructor: ({@presenter, @orientation, @onScroll}) ->
    @domNode = document.createElement('div')
    @domNode.classList.add "#{@orientation}-scrollbar"
    @domNode.style['-webkit-transform'] = 'translateZ(0)' # See atom/atom#3559
    @domNode.style.left = 0 if @orientation is 'horizontal'

    @contentNode = document.createElement('div')
    @contentNode.classList.add "scrollbar-content"
    @domNode.appendChild(@contentNode)

    @domNode.addEventListener 'scroll', @onScrollCallback

    @updateSync()

  updateSync: ->
    @oldState ?= {}
    switch @orientation
      when 'vertical'
        @newState = @presenter.state.verticalScrollbar
        @updateVertical()
      when 'horizontal'
        @newState = @presenter.state.horizontalScrollbar
        @updateHorizontal()

    if @newState.visible isnt @oldState.visible
      if @newState.visible
        @domNode.style.display = ''
      else
        @domNode.style.display = 'none'
      @oldState.visible = @newState.visible

  updateVertical: ->
    if @newState.width isnt @oldState.width
      @domNode.style.width = @newState.width + 'px'
      @oldState.width = @newState.width

    if @newState.bottom isnt @oldState.bottom
      @domNode.style.bottom = @newState.bottom + 'px'
      @oldState.bottom = @newState.bottom

    if @newState.scrollTop isnt @oldState.scrollTop
      @domNode.scrollTop = @newState.scrollTop
      @oldState = @newState.scrollTop

    if @newState.scrollHeight isnt @oldState.scrollHeight
      @contentNode.style.height = @newState.scrollHeight + 'px'
      @oldState = @newState.scrollHeight

  updateHorizontal: ->
    if @newState.height isnt @oldState.height
      @domNode.style.height = @newState.height + 'px'
      @oldState.height = @newState.height

    if @newState.right isnt @oldState.right
      @domNode.style.right = @newState.right + 'px'
      @oldState.right = @newState.right

    if @newState.scrollLeft isnt @oldState.scrollLeft
      @domNode.scrollLeft = @newState.scrollLeft
      @oldState = @newState.scrollLeft

    if @newState.scrollWidth isnt @oldState.scrollWidth
      @contentNode.style.width = @newState.scrollWidth + 'px'
      @oldState = @newState.scrollWidth

  onScrollCallback: =>
    switch @orientation
      when 'vertical'
        @onScroll(@domNode.scrollTop)
      when 'horizontal'
        @onScroll(@domNode.scrollLeft)
