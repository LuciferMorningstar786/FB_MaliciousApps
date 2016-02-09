package main

import (
	"fmt"
	"sync"
	"strings"
	"os"
	"net/http"
	"strconv"
	"io/ioutil"
	"bytes"
	"log"
)
 //i<2218310156
func visitor(url string, inChan chan string, wg *sync.WaitGroup, i int) {
	
	defer wg.Done()
	//fmt.Println("Removing task number ", i)
	client := &http.Client{}
	req, err :=http.NewRequest("GET",url,nil)
	req.Header.Set("User-Agent", "Golang Spider Bot v. 3.0")

	//fmt.Println("Currently evaluating ", url)
	if err != nil {
		log.Fatal(err)
		return
	}
	resp, err := client.Do(req)
	body, err1 :=ioutil.ReadAll(resp.Body)
	if err1 != nil {
		log.Fatal(err)
		return
	}
	resp.Body.Close()
	//fmt.Println(string(body ))
	substr1 := "Sorry"
	if !(strings.Contains(string(body),substr1)) {
		fmt.Println("Success for ", url)
		inChan <- url
	}

	return

}

func write_to_file(buff string, myChan chan string, f *os.File){
		//fmt.Println("Writing",buff, " to file!\n")
	for i:=0;; i++{
		val, ok := <-myChan
		if ok != false {
		f.WriteString(val)
		} else {
			return
		}
	}
}

func main(){
	num := 2217645684
	//endNum := 2218310156
	var buffer bytes.Buffer
	mystr := "https://apps.facebook.com/";
	var wg sync.WaitGroup
	//Concurrentmax :=500
	inChan := make(chan string, 20); //this one is to get the urls
	f,_ :=os.Create("success_ids")
	defer f.Close()
	go write_to_file(buffer.String(),inChan, f)
	const nWorkers = 100   //trying to constrain number of threads
	i:=num
	//fmt.Println("Adding to add at %v\n",i-num)
	for j:=0 ;j<nWorkers && i<2218310156;i,j = i+1,j+1{	
		wg.Add(1)
		t:= strconv.Itoa(i)
		buffer.WriteString(mystr)
		buffer.WriteString(t)
		go visitor(buffer.String(),inChan, &wg, i-num)
		buffer.Reset()
		i++
	}
		//fmt.Println(i, num+10000)
	fmt.Println("\nOut of loop\n")
	wg.Wait()
	fmt.Println("Done!\n")
	close(inChan)
	

}
