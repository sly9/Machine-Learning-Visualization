//
//  SVMLight.m
//  SVMLight
//
//  Created by Liuyi Sun on 3/22/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "SVMLight.h"
#import "svm_common.h"
#import "svm_learn.h"

@interface SVMLight(){
    NSString *docfile;           /* file with training examples */
    //    NSString *modelfile;         /* file for resulting classifier */
    NSString *testfile;
    NSString *restartfile;       /* file with initial alphas */
    DOC **docs;  /* training examples */
    
    long totwords,totdoc,i;
    double *target;
    double *alpha_in;
    KERNEL_CACHE *kernel_cache;
    LEARN_PARM learn_parm;
    KERNEL_PARM kernel_parm;
    MODEL *model;
}

@end
@implementation SVMLight

-(id) init{
    if (self=[super init]) {
        
    }
    return self;
}

-(void) dealloc{
    
}

-(NSString *) tmpFile{
    NSString *tempFileTemplate =
    [NSTemporaryDirectory() stringByAppendingPathComponent:@"svmLightTMP.XXXXXX"];
    const char *tempFileTemplateCString =
    [tempFileTemplate fileSystemRepresentation];
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);
    int fileDescriptor = mkstemp(tempFileNameCString);
    
    if (fileDescriptor == -1)
    {
        // handle file creation failure
    }
    
    // This is the file name if you need to access the file by name, otherwise you can remove
    // this line.
    NSString *tempFileName =
    [[NSFileManager defaultManager]
     stringWithFileSystemRepresentation:tempFileNameCString
     length:strlen(tempFileNameCString)];
    
    free(tempFileNameCString);
    return tempFileName;
}

-(void) trainWithPositiveData:(NSArray *)pos andNegativeData:(NSArray *)neg{
    //prepare data, write to tmp file
    docfile = [self tmpFile];
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSString *p in pos) {
        [string appendString:[NSString stringWithFormat:@"+1 %@\n",p]];
    }
    for (NSString *n in neg) {
        [string appendString:[NSString stringWithFormat:@"-1 %@\n",n]];
    }
    [string writeToFile:docfile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [self train];
}

-(void) train{
    NSLog(@"train");
    
    int argc=1;
    const char* argv[1];
    argv[0]="self";
    //    argv[1] = [[NSBundle mainBundle] pathForResource:@"train.dat" ofType:nil].UTF8String;
    
    //  argv[2] = [@"~/Library/model.dat" stringByExpandingTildeInPath].UTF8String;
    
    alpha_in=NULL;
    MODEL *aModel=(MODEL *)my_malloc(sizeof(MODEL));
    
    read_input_parameters_for_train(argc,argv,&verbosity,
                                    &learn_parm,&kernel_parm);
    read_documents(docfile.UTF8String,&docs,&target,&totwords,&totdoc);
    if(restartfile!=nil) alpha_in=read_alphas(restartfile.UTF8String,totdoc);
    
    if(kernel_parm.kernel_type == LINEAR) { /* don't need the cache */
        kernel_cache=NULL;
    }
    else {
        /* Always get a new kernel cache. It is not possible to use the
         same cache for two different training runs */
        kernel_cache=kernel_cache_init(totdoc,learn_parm.kernel_cache_size);
    }
    
    if(learn_parm.type == CLASSIFICATION) {
        svm_learn_classification(docs,target,totdoc,totwords,&learn_parm,
                                 &kernel_parm,kernel_cache,aModel,alpha_in);
    }
    else if(learn_parm.type == REGRESSION) {
        svm_learn_regression(docs,target,totdoc,totwords,&learn_parm,
                             &kernel_parm,&kernel_cache,aModel);
    }
    else if(learn_parm.type == RANKING) {
        svm_learn_ranking(docs,target,totdoc,totwords,&learn_parm,
                          &kernel_parm,&kernel_cache,aModel);
    }
    else if(learn_parm.type == OPTIMIZATION) {
        svm_learn_optimization(docs,target,totdoc,totwords,&learn_parm,
                               &kernel_parm,kernel_cache,aModel,alpha_in);
    }
    
    if(kernel_cache) {
        /* Free the memory used for the cache. */
        kernel_cache_cleanup(kernel_cache);
    }
    
    /* Warning: The model contains references to the original data 'docs'.
     If you want to free the original data, and only keep the model, you 
     have to make a deep copy of 'model'. */
    /* deep_copy_of_model=copy_model(model); */
    //write_model(modelfile,aModel);
    if (model != NULL) {
        free_model(model, 0);
    }
    model = copy_model(aModel);
    
    free(alpha_in);
    free_model(aModel,0);
    for(i=0;i<totdoc;i++) 
        free_example(docs[i],1);
    free(docs);
    free(target);
    
}
void read_input_parameters_for_train(int argc,const char *argv[],long *verbosity,
                                     LEARN_PARM *learn_parm,KERNEL_PARM *kernel_parm)
{
    long i;
    char type[100];
    
    /* set default */
    strcpy (learn_parm->predfile, "trans_predictions");
    (*verbosity)=1;
    learn_parm->biased_hyperplane=1;
    learn_parm->sharedslack=0;
    learn_parm->remove_inconsistent=0;
    learn_parm->skip_final_opt_check=0;
    learn_parm->svm_maxqpsize=10;
    learn_parm->svm_newvarsinqp=0;
    learn_parm->svm_iter_to_shrink=-9999;
    learn_parm->maxiter=100000;
    learn_parm->kernel_cache_size=40;
    learn_parm->svm_c=0.0;
    learn_parm->eps=0.1;
    learn_parm->transduction_posratio=-1.0;
    learn_parm->svm_costratio=1.0;
    learn_parm->svm_costratio_unlab=1.0;
    learn_parm->svm_unlabbound=1E-5;
    learn_parm->epsilon_crit=0.001;
    learn_parm->epsilon_a=1E-15;
    learn_parm->compute_loo=0;
    learn_parm->rho=1.0;
    learn_parm->xa_depth=0;
    kernel_parm->kernel_type=0;
    kernel_parm->poly_degree=3;
    kernel_parm->rbf_gamma=1.0;
    kernel_parm->coef_lin=1;
    kernel_parm->coef_const=1;
    strcpy(kernel_parm->custom,"empty");
    strcpy(type,"c");
    
    for(i=1;(i<argc) && ((argv[i])[0] == '-');i++) {
        switch ((argv[i])[1]) 
        { 
            case '?':  exit(0);
            case 'z': i++; strcpy(type,argv[i]); break;
            case 'v': i++; (*verbosity)=atol(argv[i]); break;
            case 'b': i++; learn_parm->biased_hyperplane=atol(argv[i]); break;
            case 'i': i++; learn_parm->remove_inconsistent=atol(argv[i]); break;
            case 'f': i++; learn_parm->skip_final_opt_check=!atol(argv[i]); break;
            case 'q': i++; learn_parm->svm_maxqpsize=atol(argv[i]); break;
            case 'n': i++; learn_parm->svm_newvarsinqp=atol(argv[i]); break;
            case '#': i++; learn_parm->maxiter=atol(argv[i]); break;
            case 'h': i++; learn_parm->svm_iter_to_shrink=atol(argv[i]); break;
            case 'm': i++; learn_parm->kernel_cache_size=atol(argv[i]); break;
            case 'c': i++; learn_parm->svm_c=atof(argv[i]); break;
            case 'w': i++; learn_parm->eps=atof(argv[i]); break;
            case 'p': i++; learn_parm->transduction_posratio=atof(argv[i]); break;
            case 'j': i++; learn_parm->svm_costratio=atof(argv[i]); break;
            case 'e': i++; learn_parm->epsilon_crit=atof(argv[i]); break;
            case 'o': i++; learn_parm->rho=atof(argv[i]); break;
            case 'k': i++; learn_parm->xa_depth=atol(argv[i]); break;
            case 'x': i++; learn_parm->compute_loo=atol(argv[i]); break;
            case 't': i++; kernel_parm->kernel_type=atol(argv[i]); break;
            case 'd': i++; kernel_parm->poly_degree=atol(argv[i]); break;
            case 'g': i++; kernel_parm->rbf_gamma=atof(argv[i]); break;
            case 's': i++; kernel_parm->coef_lin=atof(argv[i]); break;
            case 'r': i++; kernel_parm->coef_const=atof(argv[i]); break;
            case 'u': i++; strcpy(kernel_parm->custom,argv[i]); break;
            case 'l': i++; strcpy(learn_parm->predfile,argv[i]); break;
            case 'a': i++; strcpy(learn_parm->alphafile,argv[i]); break;
                //            case 'y': i++; strcpy(restartfile,argv[i]); break;
            default: printf("\nUnrecognized option %s!\n\n",argv[i]);
                
                exit(0);
        }
    }
    //    if(i>=argc) {
    //        printf("\nNot enough input parameters!\n\n");        
    //        exit(0);
    //    }
    //strcpy (docfile, argv[i]);
    //    if((i+1)<argc) {
    //  strcpy (modelfile, argv[i+1]);
    //  }
    if(learn_parm->svm_iter_to_shrink == -9999) {
        if(kernel_parm->kernel_type == LINEAR) 
            learn_parm->svm_iter_to_shrink=2;
        else
            learn_parm->svm_iter_to_shrink=100;
    }
    if(strcmp(type,"c")==0) {
        learn_parm->type=CLASSIFICATION;
    }
    else if(strcmp(type,"r")==0) {
        learn_parm->type=REGRESSION;
    }
    else if(strcmp(type,"p")==0) {
        learn_parm->type=RANKING;
    }
    else if(strcmp(type,"o")==0) {
        learn_parm->type=OPTIMIZATION;
    }
    else if(strcmp(type,"s")==0) {
        learn_parm->type=OPTIMIZATION;
        learn_parm->sharedslack=1;
    }
    else {
        printf("\nUnknown type '%s': Valid types are 'c' (classification), 'r' regession, and 'p' preference ranking.\n",type);
        
        exit(0);
    }    
    if((learn_parm->skip_final_opt_check) 
       && (kernel_parm->kernel_type == LINEAR)) {
        printf("\nIt does not make sense to skip the final optimality check for linear kernels.\n\n");
        learn_parm->skip_final_opt_check=0;
    }    
    if((learn_parm->skip_final_opt_check) 
       && (learn_parm->remove_inconsistent)) {
        printf("\nIt is necessary to do the final optimality check when removing inconsistent \nexamples.\n");
        
        exit(0);
    }    
    if((learn_parm->svm_maxqpsize<2)) {
        printf("\nMaximum size of QP-subproblems not in valid range: %ld [2..]\n",learn_parm->svm_maxqpsize); 
        
        exit(0);
    }
    if((learn_parm->svm_maxqpsize<learn_parm->svm_newvarsinqp)) {
        printf("\nMaximum size of QP-subproblems [%ld] must be larger than the number of\n",learn_parm->svm_maxqpsize); 
        printf("new variables [%ld] entering the working set in each iteration.\n",learn_parm->svm_newvarsinqp); 
        
        exit(0);
    }
    if(learn_parm->svm_iter_to_shrink<1) {
        printf("\nMaximum number of iterations for shrinking not in valid range: %ld [1,..]\n",learn_parm->svm_iter_to_shrink);
        
        exit(0);
    }
    if(learn_parm->svm_c<0) {
        printf("\nThe C parameter must be greater than zero!\n\n");
        
        
        exit(0);
    }
    if(learn_parm->transduction_posratio>1) {
        printf("\nThe fraction of unlabeled examples to classify as positives must\n");
        printf("be less than 1.0 !!!\n\n");
        
        
        exit(0);
    }
    if(learn_parm->svm_costratio<=0) {
        printf("\nThe COSTRATIO parameter must be greater than zero!\n\n");
        
        
        exit(0);
    }
    if(learn_parm->epsilon_crit<=0) {
        printf("\nThe epsilon parameter must be greater than zero!\n\n");
        
        
        exit(0);
    }
    if(learn_parm->rho<0) {
        printf("\nThe parameter rho for xi/alpha-estimates and leave-one-out pruning must\n");
        printf("be greater than zero (typically 1.0 or 2.0, see T. Joachims, Estimating the\n");
        printf("Generalization Performance of an SVM Efficiently, ICML, 2000.)!\n\n");
        
        
        exit(0);
    }
    if((learn_parm->xa_depth<0) || (learn_parm->xa_depth>100)) {
        printf("\nThe parameter depth for ext. xi/alpha-estimates must be in [0..100] (zero\n");
        printf("for switching to the conventional xa/estimates described in T. Joachims,\n");
        printf("Estimating the Generalization Performance of an SVM Efficiently, ICML, 2000.)\n");
        
        
        exit(0);
    }
}


void read_input_parameters_for_test(int argc,const char **argv, long int *verbosity, long int *pred_format)
{
    long i;
    
    /* set default */
    //    strcpy (modelfile, "svm_model");
    //    strcpy (predictionsfile, "svm_predictions"); 
    (*verbosity)=2;
    (*pred_format)=1;
    
    for(i=1;(i<argc) && ((argv[i])[0] == '-');i++) {
        switch ((argv[i])[1]) 
        { 
            case 'h': exit(0);
            case 'v': i++; (*verbosity)=atol(argv[i]); break;
            case 'f': i++; (*pred_format)=atol(argv[i]); break;
            default: printf("\nUnrecognized option %s!\n\n",argv[i]);
                exit(0);
        }
    }
    //    if((i+1)>=argc) {
    //        printf("\nNot enough input parameters!\n\n");
    //        exit(0);
    //    }
    //    strcpy (docfile, argv[i]);
    //    strcpy (modelfile, argv[i+1]);
    //    if((i+2)<argc) {
    //        strcpy (predictionsfile, argv[i+2]);
    //    }
    //    if(((*pred_format) != 0) && ((*pred_format) != 1)) {
    //        printf("\nOutput format can only take the values 0 or 1!\n\n");
    //        exit(0);
    //    }
}

-(NSArray *) testSample:(NSArray *)samples{
    testfile = [self tmpFile];
    NSMutableString *contents = [[NSMutableString alloc] init];
    for (NSString *sample in samples) {
        NSString *data = [NSString stringWithFormat:@"+1 %@\n",sample];
        [contents appendString:data];
    }
    [contents writeToFile:testfile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    return [self test];
}

-(NSArray *) test{
    NSMutableArray *labels=[[NSMutableArray alloc] init];
    int argc=1;
    const char* argv[1];
    argv[0]="self";
    
    DOC *doc;   /* test example */
    WORD *words;
    long max_docs,max_words_doc,lld;
    long queryid,slackid;
    totdoc=0;
    long wnum,pred_format;
    long j;
    double dist,doc_label,costfactor;
    char *line,*comment; 
    FILE *docfl;
    
    read_input_parameters_for_test(argc,argv,&verbosity,&pred_format);
    
    nol_ll(testfile.UTF8String,&max_docs,&max_words_doc,&lld); /* scan size of input file */
    max_words_doc+=2;
    lld+=2;
    
    line = (char *)my_malloc(sizeof(char)*lld);
    words = (WORD *)my_malloc(sizeof(WORD)*(max_words_doc+10));
    
    //    model=read_model(modelfile);
    
    if(model->kernel_parm.kernel_type == 0) { /* linear kernel */
        /* compute weight vector */
        add_weight_vector_to_linear_model(model);
    }
    if ((docfl = fopen (testfile.UTF8String, "r")) == NULL)
    { perror (testfile.UTF8String); exit (1); }
    
    while((!feof(docfl)) && fgets(line,(int)lld,docfl)) {
        parse_document(line,words,&doc_label,&queryid,&slackid,&costfactor,&wnum,
                       max_words_doc,&comment);
        totdoc++;
        if(model->kernel_parm.kernel_type == 0) {   /* linear kernel */
            for(j=0;(words[j]).wnum != 0;j++) {  /* Check if feature numbers   */
                if((words[j]).wnum>model->totwords) /* are not larger than in     */
                    (words[j]).wnum=0;               /* model. Remove feature if   */
            }                                        /* necessary.                 */
            doc = create_example(-1,0,0,0.0,create_svector(words,comment,1.0));
            dist=classify_example_linear(model,doc);
            free_example(doc,1);
        }
        else {                             /* non-linear kernel */
            doc = create_example(-1,0,0,0.0,create_svector(words,comment,1.0));
            dist=classify_example(model,doc);
            free_example(doc,1);
        }
        [labels addObject:[NSNumber numberWithDouble:dist]];
    }  
    fclose(docfl);
    free(line);
    free(words);
    return labels;
}
@end
