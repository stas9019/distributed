nbList = [
    [2,3],
    [1,3,4,5],
    [1,2,4,6],
    [2,3,5,6],
    [2,4,6,7],
    [3,4,5,7],
    [4,5,6]
]

nodesNum = 7

sentOnce = false

type Node
    father::Int
    children::Vector{Int}

    receivedSearch::Bool
end

SEARCH = 1
FATHER = 2
function sendMessage(message::Int, fromNode::Int, toNode::Int)
    global sentOnce
    global shouldSendSearch
    global Nodes

    if message == SEARCH
        if Nodes[toNode].receivedSearch == false
            #println("Accepted Message SEARCH from ", fromNode, " to ", toNode)
            Nodes[toNode].father = fromNode
            append!(shouldSendSearch, toNode)
            Nodes[toNode].receivedSearch = true
            sendMessage(FATHER, toNode, fromNode)
            sentOnce = true
        end
    elseif message == FATHER
        #println("SENT Message FATHER from ", fromNode, " to ", toNode)
        append!(Nodes[toNode].children, fromNode)
        sentOnce = true
    end
end
# prepare nodes
Nodes = []
shouldSendSearch = [1]

for i in 1:nodesNum
    push!(Nodes, Node(0, [], false))
end
Nodes[1].father = 1
Nodes[1].receivedSearch = true

while true
    sentOnce = false

    shouldSendSearchCopy = deepcopy(shouldSendSearch)
    shouldSendSearch = []

    for nodeIndex in shouldSendSearchCopy
        for nb in nbList[nodeIndex]
            #Nodes[nb].father = nodeIndex
            sendMessage(SEARCH, nodeIndex, nb)
        end
    end

    if sentOnce == false
        #println("END")
        break
    end
end

for i in 1:nodesNum
    print("Node ",i,": FATHER - ", Nodes[i].father, ", Children - ")
    for child in Nodes[i].children
        print(child,", ")
    end
    println()
end
