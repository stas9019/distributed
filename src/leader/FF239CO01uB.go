// _Channels_ are the pipes that connect concurrent
// goroutines. You can send values into channels from one
// goroutine and receive those values into another
// goroutine.
package main
import "fmt"
func main() {

    // Neighbours list

    ids := []int{23, 117, 56}

	nbs := [][]int{
    	{2, 1},
   		{0, 2},
		{1, 0},
	}

	n := len(nbs)

	var channels [](chan int)

    for i := 0; i < n; i++ {
        channels = append(channels, make(chan int, n))
    }

	for i := 0; i < n; i++ {
		go func(i int) {
			forw := i

			back := (i-1)
			if i-1 == -1{
				back = n-1
			}

            channels[forw] <- ids[i]
			fmt.Println(" Sending forward My id = ", ids[i])
			//channels[back] <- "My id "+strconv.Itoa(i)

            myID := ids[i]

            for true{
                receivedID := <-channels[back]
                fmt.Println(myID, "received My id = ", receivedID)

                if receivedID > myID{
                    channels[forw] <- receivedID
                }else if receivedID < myID{
                    continue
                }else if receivedID == myID{
                    fmt.Println(myID, "is a leader ")
                    break
                }
            }
            // select {
            //     // case msg1 := <-channels[forw]:
            //     //     fmt.Println(i, "received from next", msg1)
            //     case msg2 := <-channels[back]:
            //         fmt.Println(i, "received from prev", msg2)
            //     }

		}(i)
	}

    // The `<-channel` syntax _receives_ a value from the
    // channel. Here we'll receive the `"ping"` message
    // we sent above and print it out.
	var input string
    fmt.Scanln(&input)
    fmt.Println("done")
}
