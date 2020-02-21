#### UK data table #####


output$erosiontable <- DT::renderDataTable({
  DT::datatable(cleantable, 
                escape = FALSE,
                plugins = "ellipsis",
                extensions = c('Buttons','FixedColumns','FixedHeader', 'Scroller'),
                options = list(
                  #pageLength = 25,
                  orderClasses = TRUE,
                  dom = 'Bfrtlip',
                  buttons = 'csv',
                  scrollX = TRUE,
                  fixedColumns = list(leftColumns = 4),
                  fixedHeader = TRUE,
                  deferRender = TRUE,
                  scrollY = 480,
                  scroller = TRUE,
                  columnDefs = list(list(
                    targets = 20,
                    render = JS("$.fn.dataTable.render.ellipsis(20, false)")
                    )))
  )
})

 #version without working links
#output$erosiontable <- DT::renderDataTable(
#  cleantable,
#  plugins = "ellipsis",
#  options = list(
#    pageLength = 25,
#    columnDefs = list(list(
#      targets = c(20,21),
#      render = JS("$.fn.dataTable.render.ellipsis(20, false )")
#    ))
#  ))


