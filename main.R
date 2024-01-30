# en aquest fitxer pots especificar els paràmetres a utilitzar per a generar l'informe dinàmic
# el primer paràmetre, data, espera que se li doni un fitxer de tipus csv; el segon conté els 
# valors de k que es provaran, i l'últim conté el nom de la columna/variable que conté la classe
# a predir
rmarkdown::render('PEC4-R.Rmd', 
                  params=list(data = 'input_data/ECGCvdata.csv', 
                              ks_to_try=c(1, 3, 5, 7), class='ECG_signal'), 
                  output_format=c("pdf_document", "html_document"))

system("./mv-output.sh")