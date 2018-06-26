#include <iostream>
#include <string>

using namespace std;
struct token{
    string type;
    string val;
    token* next;
};

token* start = NULL;
token* str_end = NULL;
int count_token = 0;//記token
string Dcl[] = {"strdcl", "id", "Astring"};
string Astring[] = {"quote", "string", "quote"};
string Stmt[] = {"print", "id"};

token* establish(){
    token* str = new token;
    if(start == NULL){
        start = str;
        str_end = str;
    }
    else{
        str_end->next = str;
        str_end = str;
    }
    return str;
}

void scanner(string temp){
    token* str;
    string token_string = "";
    bool check_wnum = true;
    if(temp.size() > 1){
        int test_string = 0;
        if(temp[0] == '"'){
            str = establish();
            str->type = "quote";
            str->val = temp[0];
            test_string += 1;
            count_token += 1;
        }
        for(int i = test_string; i < temp.size(); i++){
            token_string = "";
            if(temp[i] == '"'){
                for(int j = test_string; j < i; j++){
                    token_string += temp[j];
                }
                if(check_wnum){
                    str = establish();
                    str->type = "string";
                    str->val = token_string;
                    count_token += 1;

                }
                str = establish();
                str->type = "quote";
                str->val = temp[i];
                count_token += 1;

                    test_string = i + 1; //point to the next character.
                    token_string = ""; //clean the temp string for next.
                }
                else if(((int)temp[i] > 96 && (int)temp[i] < 123) || ((int)temp[i] > 64 && (int)temp[i] < 91) || ((int)temp[i] > 47 && (int)temp[i] < 58)){
                   if(i == temp.size() - 1){
                    for(int j = test_string; j <= i; j++){
                        token_string += temp[j];
                    }
                    if(check_wnum){
                        str = establish();
                        str->type = "string";
                        str->val = token_string;
                        count_token += 1;
                    }
                }
            }else{
                check_wnum = false;
            }    
        }
    }
    else{
        if(temp[0] == 's'){
            str = establish();
            str->type = "strdcl";
            str->val = temp;
            count_token += 1;
        }
        else if(((int)temp[0] > 96 && (int)temp[0] < 112) || (int)temp[0] == 113 || (int)temp[0] == 114 || ((int)temp[0] > 115 && (int)temp[0] < 123)){
            str = establish();
            str->type = "id";
            str->val = temp;
            count_token += 1;
        }
        else if(temp[0] == 'p'){
            str = establish();
            str->type = "print";
            str->val = temp;
            count_token += 1;
        }
    }
}

//parse
bool parse(token* tokens){
    int Dcl_size = sizeof(Dcl) / sizeof(Dcl[0]);
    int Astring_size = sizeof(Astring) / sizeof(Astring[0]);
    int Stmt_size = sizeof(Stmt) / sizeof(Stmt[0]);
    int count_tok = 0;
    
    if(tokens->type == "strdcl"){
        for(int i = 0; i < Dcl_size; i++){
            if(count_tok > count_token){
                return false;
            }else{
                if(tokens->type == Dcl[i]){
                    tokens = tokens->next;
                    count_tok += 1;
                }else if(Dcl[i] == "Astring"){
                    for(int j = 0; j < Astring_size; j++){
                        if(count_tok > count_token){
                            return false;
                        }else{
                            if(tokens->type != Astring[j]){
                                return false;
                            }
                            tokens = tokens->next;
                            count_tok += 1;    
                        }
                    }
                }else{
                    return false;
                }
            }

        }   
    }
    if(count_tok < count_token){
        if(tokens->type == "print"){
            for(int i = 0; i < Stmt_size; i++){
                if(count_tok > count_token){
                    return false;
                }else{
                    if(tokens->type == Stmt[i]){
                        tokens = tokens->next;
                    }else{
                        return false;
                    }
                    count_tok += 1;
                }
            }   

        }
    }
    if(count_tok < count_token){
        if(tokens->type != "print" && tokens->type != "strdcl"){
            return false;
        }
    }

    if(count_tok == count_token){
        return true;    
    }else{
        return false;
    }
    
}



int main(){
    bool checker = true; //輸出判斷
    string inputStr = "";
    //cout << "請以‘-1’結束輸入：" << endl;
    while(cin >> inputStr){
        if(inputStr == "-1"){
            break;
        }
        scanner(inputStr);
    }
    checker = parse(start);
    if(checker){
        cout << start->type << " " << start->val << endl;
        for(int i = 0 ; i < count_token - 1 ; i++){
            start = start->next;
            cout << start->type << " " << start->val << endl;
        }
    }else{
        cout << "valid input" << endl;
    }
    return 0;
}
