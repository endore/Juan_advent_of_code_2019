using DelimitedFiles
using DataFrames
function partOne()
    # part one
    input_arr = readdlm("day6\\input.txt", ',', String)
    return orbit_count_checksum(input_arr)
end

function orbit_count_checksum(input_arr)
    # format input
    input_df = clean_input(input_arr)

    #: initiate total orbits with all unique objects in input_arr
    total_orbits_dict = initiate_total_orbits_dict(input_df)

    COM_leafs = get_leafs(input_df,"COM")

    if length(COM_leafs) == 0
        throw(DomainError(parent_to_leafs,"No COM parent entry found"))
    end

    #: update total_orbits_dict starting from parent = "COM" and using the parent_to_leafs
    update_orbits!(total_orbits_dict,input_df)

    #return sum of total_orbits_dict values
    return sum(values(total_orbits_dict))
end

function clean_input(input)
    output = split.(input,")")
    df = DataFrame(Parent = String[], Child = String[])
    for i in output
        push!(df,(i[1],i[2]))
    end
    return df
end

function initiate_total_orbits_dict(input_clean)
    dict = Dict{String,Int}()
    for i in union(input_clean.Parent,input_clean.Child)
        dict[i] = 0
    end
    return dict
end

function update_orbits!(total_orbits_dict,clean_input, parent = "COM")
    children = get_leafs(clean_input,parent)
    for child in children
        total_orbits_dict[child] = total_orbits_dict[parent] + 1
        update_orbits!(total_orbits_dict,clean_input,child)
    end
end

function get_leafs(input_df,parent)
    return input_df.Child[input_df.Parent .== parent,:]
end
