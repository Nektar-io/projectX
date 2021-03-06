#' Create a string for SQL INSERTion
#' @export

sqlString <- function(vals) {
  paste(
    sapply(vals, function(val) {
      if (is.numeric(val) | any(c("POSIXct", "POSIXlt") %in% class(val)))
        return(val)
      else
        return(paste0("'", val, "'"))
    }),
    sep = "",
    collapse = ", "
  )
}

#' Create an empty SQL table
#' 
#' @export

createDBTbl <- function(conn, tbl, key = NULL) {
  if ("src_sqlite" %in% class(conn))
    conn <- conn$con
  
  cols <- sapply(tbl, function(x) {
    cls <- switch(
      class(x),
      "integer" = "INTEGER",
      "numeric" = "REAL",
      "character" = "TEXT",
      "BLOB")
    
    return(c(cls))
  })
  
  colString <- paste(sapply(names(cols), function(name) {
    type <- cols[[name]]
    if (name %in% key)
      type <- paste(type, "PRIMARY KEY ASC")
    
    return(paste(name, type, sep = " "))
  }), collapse = ", ")
  
  string <- paste0('CREATE TABLE IF NOT EXISTS "', substitute(tbl), '"  (', colString, ')')
  
  dbSendQuery(
    conn = conn,
    statement = string
  )
  invisible(collapse(tbl))
}

#' @export
dropDBTbl <- function(conn, name) {
  if ("src_sqlite" %in% class(conn))
    conn <- conn$con
  
  name <- as.character(substitute(name))
  string <- paste0('DROP TABLE IF EXISTS ', name)
  
  invisible(dbSendQuery(
    conn = conn,
    statement = string
  ))
}

#' Insert rows at the bottom of a dplyr (local) tbl
#' 
#' Insert one or several rows at the bottom of a dplyr tbl. The function can also automatically create a new ID for the item in question.
#' @export

insert <- function(tbl, row, conn, create_id = FALSE, idcol = NULL, return_tbl = TRUE) {
  if ("src_sqlite" %in% class(conn))
    conn <- conn$con
  
  idcol <- idcol %||% "Id"
  if (!"tbl_sql" %in% class(tbl)) {
    tblnms <- names(tbl)
  } else {
    tblnms <- names(collect(head(tbl, n = 1L)))
  }
  
  # Create an index if none is supplied
  if (create_id) {
    # Error handling
    if (!idcol %in% tblnms) {
      stop("The submitted IDCOL is not in the names of the TBL argument.")
    }
    
    # Handle empty tables
    if (nrow(tbl) == 0) {
      max_id <- 0
    } else {
      max_id <- max(collect(select(tbl, matches(idcol))))
    }
    row[[idcol]] <- max_id + 1:unique(sapply(row, length))
  }
  
  if (!is.null(names(row))) {
    # If ROW is named, check to see that the names match
    row <- row[,tblnms]
  } else {
    # If ROW is _not_ named, check that the length of the args matches.
    rowlng <- length(row)
    if (create_id) rowlng <- rowlng + 1
    if (rowlng > ncol(tbl))
      stop("The length of ROW is larger than the number of columns in TBL.")
  }
  
  if (length(unique(sapply(row, length))) > 1)
    stop("The number of elements in each supplied column in the ROW argument is not identical.")
  
  # Convert vectors to lists to simplify data handling
  if (is.vector(row))
    row <- as.list(row)
  
  # Name handling: Name unnamed data
  if (is.null(names(row))) {
    nms <- names(tbl)
    if (create_id) {
      nms <- nms[!nms %in% idcol]
    }
    names(row) <- nms
  }
  
  # If the data is a local tbl: Bind the row(s) to the data and return it
  if (!"tbl_sql" %in% class(tbl)) {
    if (is.data.frame(row)) {
      tbl <- rbind_all(list(tbl, row))
    } else {
      tbl <- rbind(tbl, row)
      if (ncol(tbl) > length(row))
        warning("Elements in ROW outside the range of the TBL were dropped.")
    }
    
    # Convert to a dplyr tbl_df
    if (return_tbl) {
      tbl <- tbl_df(tbl)
    }
  } else {
    
    # If the data is in a remote sql DB: pass an INSERT statement to
    # the database
    
    dbSendQuery(
      conn = conn,
      statement = paste0("INSERT INTO ", as.character(tbl$from),
                         " VALUES (", sqlString(row),")")
    )
    collapse(tbl)
  }
  
  return(tbl)
}