#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###### Seleciona e agrega microdados dos setores censitarios

# carregar bibliotecas
source('./0_setup.R')

# Cria data.frame com municipios do projeto
munis_df <- data.frame(code_muni = c(3300803,3304300,3302007,	3302700,	3302858,	3305554,	3305752,	3301850,	3302270,	3304144,	3300456,	3301702,	
                                     3301900,3302502,3303203,3303302,3303500,3303609,3304557,3304904,3305109,2304400,3550308,4106902,3106200,2927408,1501402,5300108), 
                       name_muni=c('cachoeiras de macacu','rio bonito','itaguai','marica','mesquita','seropedica','tangua','guapimirim',
                                   'japeri','queimados','belford roxo','duque de caxias','itaborai','mage','nilopolis','niteroi','nova iguacu',
                                   'paracambi','rio de janeiro','sao goncalo','sao joao de meriti','fortaleza','sao paulo','curitiba',
                                   'belo horizonte','salvador','belem','distrito federal'),
                       abrev_state=c('RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ','RJ',
                                     'RJ','RJ','RJ','RJ','RJ','RJ','RJ','CE','SP','PR','MG','BA','PA','DF'),
                       rm=c('rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj',
                            'rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj','rmrj',
                            'rmrj','rmrj','rmrj','rmf','rmsp','rmc','rmbh','rms','rmb','ride-df'))

### 1. Carrega micro dados dos setores censitarios --------------------------------------------------

## Leitura dos dados
setores #310120 | 2837
setores1 <- data.table::fread("../dados/apoio/dados_censo2010A.csv",
                              select = c('Pess3_V168','Pess3_V170','Pess3_V173','Pess3_V175','Pess3_V178','Pess3_V180','Pess3_V183',
                                         'Pess3_V185','Pess3_V198','Pess3_V200','Pess3_V203','Pess3_V205','Pess3_V208','Pess3_V210',
                                         'Pess3_V213','Pess3_V215','Pess3_V218','Pess3_V220','Pess3_V223','Pess3_V225','Pess3_V228',
                                         'Pess3_V230','Pess3_V233','Pess3_V235','Pess3_V238','Pess3_V240','Pess3_V243','Pess3_V245',
                                         'Pess5_V007','Pess5_V009','RespRend_V045','RespRend_V046','RespRend_V047','DomRend_V005', 
                                         'DomRend_V006','DomRend_V007','DomRend_V008','DomRend_V009', 'DomRend_V010', 'DomRend_V011', 
                                         'DomRend_V012','DomRend_V013','DomRend_V014'))setores <- data.table::fread("./dados/apoio/dados_censo2010A.csv")
names(setores1)

# filtra apenas municipio do projeto
setores1 <- setores1[Cod_municipio %in% munis_df$code_muni,]

## Renomeia variaveis
#Revisar~~~~~~~~~~~~~~~~~~~~~~~~
# Renda 6.19 - variavel escolhida: V003 = Total do rendimento nominal mensal dos domicílios particulares permanentes
setores_renda <-  setores1 %>% 
  dplyr::select(cod_uf = Cod_UF, cod_muni = Cod_municipio, cod_setor = Cod_setor, renda_total = DomRend_V003, moradores_total = Dom2_V002, cor_branca=Pess3_V002, cor_preta=Pess3_V003, cor_amarela=Pess3_V004, cor_parda=Pess3_V005, cor_indigena=Pess3_V006)

# Criar variavel de renda domicilias per capita de cada setor censitario
setDT(setores_renda)[, renda_per_capta := renda_total / moradores_total]
setores_renda[, cod_setor := as.character(cod_setor)]

##### Dados que precisam ser filtrados -------------
#Dados que precisam ser incluídos
#Cod_UF # Codigo da UF
#Cod_municipio # Codigo do municipio
#Cod_setor # Codigo do setor censitario
#DomRend_V003 # Total do rendimento nominal mensal dos domicílios particulares permanentes
#Dom2_V002 # Moradores em domicílios particulares permanentes
#Basico_V002 # Moradores em domicílios particulares permanentes ou população residente em domicílios particulares permanentes
#Pess3_V002 # Pessoas Residentes e cor ou raça - branca
#Pess3_V003 # Pessoas Residentes e cor ou raça - preta
#Pess3_V004 # Pessoas Residentes e cor ou raça - amarela
#Pess3_V005 # Pessoas Residentes e cor ou raça - parda
#Pess3_V006 # Pessoas Residentes e cor ou raça - indígena 
#Pess3_V168 # Pessoas de 5 ou 6 anos de idade, do sexo feminino e cor ou raça - preta
#Pess3_V170 # Pessoas de 5 ou 6 anos de idade, do sexo feminino e cor ou raça - parda
#Pess3_V173 # Pessoas de 7 a 9 anos de idade, do sexo feminino e cor ou raça - preta
#Pess3_V175 # Pessoas de 7 a 9 anos de idade, do sexo feminino e cor ou raça - parda
#Pess3_V178 # Pessoas de 10 a 14 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V180 # Pessoas de 10 a 14 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V183 # Pessoas de 15 a 19 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V185 # Pessoas de 15 a 19 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V198 # Pessoas de 20 a 24 anos de idade, do sexo feminino e cor ou raça - preta
#Pess3_V200 # Pessoas de 20 a 24 anos de idade, do sexo feminino e cor ou raça - parda
#Pess3_V203 # Pessoas de 25 a 29 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V205 # Pessoas de 25 a 29 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V208 # Pessoas de 30 a 34 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V210 # Pessoas de 30 a 34 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V213 # Pessoas de 35 a 39 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V215 # Pessoas de 35 a 39 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V218 # Pessoas de 40 a 44 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V220 # Pessoas de 40 a 44 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V223 # Pessoas de 45 a 49 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V225 # Pessoas de 45 a 49 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V228 # Pessoas de 50 a 54 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V230 # Pessoas de 50 a 54 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V233 # Pessoas de 55 a 59 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V235 # Pessoas de 55 a 59 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V238 # Pessoas de 60 a 69 anos de idade, do sexo feminino e cor ou raça – preta
#Pess3_V240 # Pessoas de 60 a 69 anos de idade, do sexo feminino e cor ou raça – parda
#Pess3_V243 # Pessoas de 70 anos ou mais de idade, do sexo feminino e cor ou raça – preta
#Pess3_V245 # Pessoas de 70 anos ou mais de idade, do sexo feminino e cor ou raça – parda
#Pess5_V007 # Pessoas de 0 a 4 anos de idade, do sexo feminino e cor ou raça - preta
#Pess5_V009 # Pessoas de 0 a 4 anos de idade, do sexo feminino e cor ou raça - parda
#RespRend_V045 # Pessoas responsáveis com rendimento nominal mensal de até ½ salário mínimo, do sexo feminino
#RespRend_V046 # Pessoas responsáveis com rendimento nominal mensal de mais de 1/2 a 1 salário mínimo, do sexo feminino
#RespRend_V047 # Pessoas responsáveis com rendimento nominal mensal de mais de 1 a 2 salários mínimos, do sexo feminino
#DomRend_V005 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de até
1/8 salário mínimo
#DomRend_V006 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 1/8 a 1/4 salário mínimo
#DomRend_V007 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 1/4 a 1/2 salário mínimo
#DomRend_V008 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de
mais de 1/2 a 1 salário mínimo
#DomRend_V009 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 1 a 2 salário mínimo
#DomRend_V010 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 2 a 3 salários mínimos
#DomRend_V011 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 3 a 5 salários mínimos
#DomRend_V012 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 5 a 10 salários mínimos
#DomRend_V013 # Domicílios particulares com rendimento nominal mensal domiciliar per capita de mais de 10 salários mínimos
#DomRend_V014 # Domicílios particulares sem rendimento nominal mensal domiciliar per capita

### 2. Merge dos dados de renda com shapes dos setores censitarios --------------------------------------------------

# funcao para fazer merge dos dados e salve arquivos na pata 'data'
merge_renda_setores <- function(sigla){
  
  #  sigla <- "for"
  
  # status message
  message('Woking on city ', sigla_muni, '\n')
  
  # codigo do municipios
  code_muni <- subset(munis_df, abrev_muni==sigla )$code_muni
  
  # subset dados dos setores
  dados <- subset(setores_renda, cod_muni == code_muni)
  
  # leitura do shape dos setores
  sf <- readr::read_rds( paste0("../data-raw/setores_censitarios/", sigla,"/setores_", sigla,".rds") )
  
  # merge
  sf2 <- dplyr::left_join(sf, dados, c('code_tract'='cod_setor'))
  
  # salvar
  readr::write_rds(sf2,  paste0("../data/setores_agregados/setores_agregados_", sigla,".rds"))
}


# aplicar funcao
purrr::walk(munis_df$abrev_muni, merge_renda_setores)

