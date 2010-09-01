module SpreadsheetOnRails

  class Handler < ::ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable

    def compile(template)
      %Q{controller.response.content_type ||= Mime::XLS
         controller.headers["Content-Disposition"] = "attachment"
         SpreadsheetOnRails::Base.new { |workbook| #{template.source} }.process}
    end

  end

  class Base

    def initialize
      yield workbook
    end

    def workbook
      @workbook ||= Spreadsheet::Workbook.new
    end

    def process
      sio = StringIO.new
      workbook.write(sio)
      sio.string
    end
  end
end
