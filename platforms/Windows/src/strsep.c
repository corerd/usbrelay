/**
 * strsep() isn't Standard C, so it may not be available in some toolchain.
 * 
 * The following has been self implemented by: 
 * https://stackoverflow.com/a/8514474
 */

#include <stdio.h>
#include <string.h>


/**
 * Extract token from string
 * 
 * If *stringp is NULL, the strsep() function returns NULL and does nothing else.
 * Otherwise, this function finds the first token in the string *stringp,
 * that is delimited by one of the bytes in the string delim.
 * This token is terminated by overwriting the delimiter with a null byte ('\0'),
 * and *stringp is updated to point past the token.
 * In case no delimiter was found, the token is taken to be the entire
 * string *stringp, and *stringp is made NULL.
 * 
 * It returns a pointer to the token,
 * that is, it returns the original value of *stringp.
 */
char* strsep(char** stringp, const char* delim)
{
    char* start = *stringp;
    char* p = (start != NULL) ? strpbrk(start, delim) : NULL;

    if (p == NULL)
    {
        *stringp = NULL;
    }
    else
    {
        *p = '\0';
        *stringp = p + 1;
    }

    return start;
}
