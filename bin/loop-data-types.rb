types = %w(BIGINT INT INT_AUTO INT_SIGNED TINYINT BOOLEAN DATE DATETIME DATETIME_INSERT DATETIME_UPDATE DECIMAL ENUM ENUM_CUSTOM TEXT LONG_TEXT VARCHAR)

types.each do |type|

    output = "        testCases.add(Arrays.asList(\"field_#{type.downcase}\", DataType.#{type}, Arrays.asList(\"\"));"

    puts output
end
#
# types.each do |type|
#
#     output = <<-FOO
#
#         metaData.put(FIELD_#{type}, new HashMap<String, Object>() {{
#             put(DATA_TYPE, DataType.#{type});
#             put(MAX_LENGTH, null);
#         }});
#     FOO
#
#     puts output
# end