class PostLinkInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    "<div class='row'>
      <div class='col-9'>
        #{@builder.text_field(attribute_name, merged_input_options)}
      </div>

      <div class='col-3'>
        <a href='#' class='btn btn-outline-secondary' id='fetch-post-title'>Pobierz tytuł</a>
      </div>
    </div>".html_safe
  end
end
