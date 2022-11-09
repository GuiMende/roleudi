@RestResource(urlMapping='/Comercios/*')

//https://roleudi-dev-ed.lightning.force.com/services/apexrest/Comercios/

global with sharing class getComerce {

    @HttpGet
    global static void getComercios(){

        RestResponse resultRest = RestContext.response;
        RestRequest request = RestContext.request;

        String WhatsName = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        String WhatsCategoria = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Comerce__c> comerceList = new List<Comerce__c>();

        //Filtro por Nome
        if (String.isNotBlank(WhatsName)) {
            comerceList = [SELECT id,Name,Endereco__c,Telefone__c,Instagram__c,Categoria__c FROM Comerce__c WHERE Name =:WhatsName];
        }
        
        //Filtro por categoria
        if (String.isNotBlank(WhatsCategoria)) {
            comerceList = [SELECT id,Name,Endereco__c,Telefone__c,Instagram__c,Categoria__c FROM Comerce__c WHERE Categoria__c =:WhatsCategoria];
        }
        else {
            comerceList = [SELECT id,Name,Endereco__c,Telefone__c,Instagram__c,Categoria__c  FROM Comerce__c];
        }
                

        resultRest.responseBody = Blob.valueOf(JSON.serializePretty(comerceList));
        resultRest.statusCode = 200;

    }

    @HttpPost(urlMapping='/post/')
    global static void insertComercios(List<InserirComercios> comerciosInsert){

            RestResponse resultRest = RestContext.response;
    
            List<Categoria__c> comerciosInsertList = new List<Lead>();
    
        for (InserirComercios l : comerciosInsert){
            Categoria__c categoriainserte = new Lead(
                Name = l.nome,
                Endereco__c = l.endereco,
                Telefone__c = l.telefonee,
                Instagram__c = l.instaa,
                Categoria__c = l.category
                );
                comerciosInsertList.add(categoriainserte);
        }
    
            List<Id> idsResponse = new List<Id>();
    
            if (comerciosInsertList.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(comerciosInsert);
    
                for(Integer index = 0,size = results.size(); index < size; index ++){
    
                    if(results[index].isSuccess()){
                        idsResponse.add(results[index].id);
                    }else {
                        idsResponse.add('ERROR');
                    }
                }
            }
    
            resultRest.responseBody = Blob.valueOf(JSON.serializePretty(idsResponse));
            resultRest.statusCode = 200;
        }
    }
}
