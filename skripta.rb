 require "google_drive"

 session = GoogleDrive::Session.from_config("config.json")

#  ws1 = session.spreadsheet_by_key("1C6JS-s0FILAkT_obJcPPIonTvBnYdlX2DMu9Vo2ebPs").worksheets[0]
#  ws2 = session.spreadsheet_by_key("1C6JS-s0FILAkT_obJcPPIonTvBnYdlX2DMu9Vo2ebPs").worksheets[1]


class Table
    include Enumerable

    def initialize(worksheet)
        @worksheet = worksheet
        @header_arr
        @start_row
        @start_col
        set_values(worksheet)
        create_methods
    end

    attr_accessor :header_arr, :start_row, :start_col, :worksheet
    attr_reader :header_arr, :start_row, :start_col, :worksheet

    def each
         @worksheet.rows[start_row - 1..-1].each do |row|
             row[start_col - 1..-1].each do |field|
                 yield field
             end
        end
    end

    def worksheet_to_table
        table_arr = Array.new
        (1..@worksheet.num_rows).each do |row|
            col_arr = Array.new
            (1..@worksheet.num_cols).each do |col|
                field = @worksheet[row, col]
                col_arr << field unless field == ""
            end
            table_arr << col_arr if col_arr.any?
        end
        table_arr
    end

    def row(num)
        @worksheet.rows[num + @start_row - 1][@start_col-1..-1]
    end

    def [](col_name)
        get_column(col_name)
    end

    def get_row_from_field(field_name)
        @worksheet.rows[start_row..-1].each do |row|
            return row[start_col-1..-1] if row.include?(field_name.to_s)
        end

    end

    def update_value(row, col, value)
        @worksheet[row, col] = value
        @worksheet.save

    end

    private
     def set_values(ws)
         cnt_row = 1
         (1..ws.num_rows).each do |row|
             col_arr = Array.new
             cnt_col = 1
             flag = true
             (1..ws.num_cols).each do |col|
                if ws[row, col] != ""
                    col_arr << ws[row, col]
                    flag = false
                end
                cnt_col += 1 if flag     
             end
             if col_arr.any?
                @header_arr = col_arr
                @start_row = cnt_row
                @start_col = cnt_col
                break
             end
             cnt_row +=1     
         end
     end
     def create_methods
            @header_arr.each do |header|
                camel_header = camelcase(header)
                    self.class.class_eval {
                        define_method(camel_header) do
                            get_column(header)
                        end
                    }
            end
        end
    def get_column(header)
        col_arr = Array.new
        @worksheet.rows[start_row..-1].each do |row|
            index = start_col + @header_arr.index(header) - 1
            col_arr << row[index]
        end
        Column.new(col_arr, self, header)
    end

    def camelcase(str)
        new_str = str.split(' ').collect(&:capitalize).join
            new_str[0] = str[0].downcase
            new_str
        end    
end

class Column < Array

    include Enumerable

    def initialize(arr, tableParent, header)
        super(arr)
        @tableParent = tableParent
        @header = header
    end

    def []=(row, value)
        index_col =  @tableParent.start_col + @tableParent.header_arr.index(@header)
        index_row = @tableParent.start_row + row
        @tableParent.update_value(index_row, index_col, value)

    end

    def map(&block)
        result = []
        self.each do |element|
            element = element.to_i if element.to_i.to_s == element
            index_col = @tableParent.header_arr.index(@header) + @tableParent.start_col
            index_row = self.index(element.to_s) + @tableParent.start_row + 1
            result << yield(element)
            @tableParent.update_value(index_row, index_col, result[-1])
        end  
        result
    end

    def select(&block)
        result = []
        self.each do |element|
            element = element.to_i if element.to_i.to_s == element
            result << element if yield(element) == true
        end
        result
    end

    def reduce(&block)
        sum = 0
        self.each do |element|
            sum = yield(sum, element.to_i)
        end
        sum
    end

    def sum
        res = 0
        self.each do |element|
            res += element.to_i if element.to_i.to_s == element
        end
        res
    end

    def avg
        self.sum/self.size
    end
    def method_missing(field_name)
        @tableParent.get_row_from_field(field_name)
    end
end






