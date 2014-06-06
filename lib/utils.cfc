/**
 * @output false
 */
component {

    /**
     * http://www.cflib.org/udf/arraySlice
     * Slices an array.
     *
     * @param ary      The array to slice. (Required)
     * @param start      The index to start with. Defaults to 1. (Optional)
     * @param finish      The index to end with. Defaults to the end of the array. (Optional)
     * @return Returns an array.
     * @author Darrell Maples (drmaples@gmail.com)
     * @version 1, July 13, 2005
     */
    function arraySlice(ary) {
        var start = 1;
        var finish = arrayLen(ary);
        var slice = arrayNew(1);
        var j = 1;

        if (len(arguments[2])) { start = arguments[2]; };
        if (len(arguments[3])) { finish = arguments[3]; };

        for (j=start; j LTE finish; j=j+1) {
            arrayAppend(slice, ary[j]);
        }
        return slice;
    }

}