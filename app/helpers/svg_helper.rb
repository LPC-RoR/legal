module SvgHelper

  BOOTSTRAP_COLORS = {
    'primary'   => '#0d6efd',
    'secondary' => '#6c757d',
    'success'   => '#198754',
    'danger'    => '#dc3545',
    'warning'   => '#ffc107',
    'info'      => '#0dcaf0',
    'light'     => '#f8f9fa',
    'dark'      => '#212529',
    'white'     => '#ffffff',
    'black'     => '#000000',
  }.freeze

  ICONS = {
    'list-task' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-list-task" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M2 2.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5V3a.5.5 0 0 0-.5-.5H2zM3 3H2v1h1V3z"/><path d="M5 3.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zM5.5 7a.5.5 0 0 0 0 1h9a.5.5 0 0 0 0-1h-9zm0 4a.5.5 0 0 0 0 1h9a.5.5 0 0 0 0-1h-9z"/><path fill-rule="evenodd" d="M1.5 7a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5H2a.5.5 0 0 1-.5-.5V7zM2 7h1v1H2V7zm0 3.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5H2zm1 .5H2v1h1v-1z"/></svg>',

    'file-earmark' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark" viewBox="0 0 16 16"><path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5z"/></svg>',

    'file-earmark-pdf' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-pdf" viewBox="0 0 16 16"><path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/><path d="M4.603 14.087c-.828 0-1.335-.722-1.335-1.78 0-1.075.537-1.807 1.406-1.807.828 0 1.335.722 1.335 1.78 0 1.075-.537 1.807-1.406 1.807zm.006-2.766c-.497 0-.82.53-.82 1.002 0 .464.31.979.82.979.497 0 .82-.53.82-1.002 0-.464-.31-.979-.82-.979zm2.538-1.304h1.452c.604 0 .927-.364.927-.955 0-.558-.34-.924-.927-.924h-1.452v1.879zm0 3.062h1.693c.69 0 1.065-.37 1.065-1.073 0-.665-.38-1.05-1.065-1.05H7.147v2.123zm4.508-3.062h1.452c.604 0 .927-.364.927-.955 0-.558-.34-.924-.927-.924h-1.452v1.879zm0 3.062h1.693c.69 0 1.065-.37 1.065-1.073 0-.665-.38-1.05-1.065-1.05h-1.693v2.123z"/></svg>',

    'diamond-half' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-diamond-half" viewBox="0 0 16 16"><path d="M9.05.435c-.58-.58-1.52-.58-2.1 0L.436 6.95c-.58.58-.58 1.519 0 2.098l6.516 6.516c.58.58 1.519.58 2.098 0l6.516-6.516c.58-.58.58-1.519 0-2.098L9.05.435zM8 .989c.127 0 .253.049.35.145l6.516 6.516a.495.495 0 0 1 0 .7L8.35 14.866a.493.493 0 0 1-.35.145V.989z"/></svg>',

    'arrow-return-right' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .707.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/></svg>',
  }.freeze

  def bi_icon(name, width: 16, height: 16, fill: 'currentColor', **options)
    svg = ICONS[name.to_s]
    return content_tag(:span, "[icon:#{name}]") unless svg

    # Resuelve el color si viene como nombre bootstrap
    color = BOOTSTRAP_COLORS[fill.to_s] || fill

    svg = svg.dup
    svg.sub!(/width="\d+"/, %(width="#{width}"))
    svg.sub!(/height="\d+"/, %(height="#{height}"))
    svg.sub!(/fill="[^"]*"/, %(fill="#{color}"))

    if options[:class]
      svg.sub!(/class="([^"]*)"/, %(class="\\1 #{options[:class]}"))
    end

    svg.html_safe
  end

end