$(function() {
  // DATE UTILITY FUNCTIONS
  Date.prototype.startOfWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() - this.getDay()
    );
  };
  Date.prototype.endOfWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() + 6 - this.getDay()
    );
  };
  Date.prototype.endOfNextWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() + 13 - this.getDay()
    );
  };
  Date.prototype.startOfMonth = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      1
    );
  };
  Date.prototype.endOfMonth = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth() + 1,
      0 //0 is equal to last day of next month
    );
  };

  // ********* INITIALIZATION *********
  var date1 = new Date(gon.date1);
  var date2 = new Date(gon.date2);
  date1.setDate(date1.getDate() + 1);
  date1.setDate(date2.getDate() + 1);

  var filter = gon.filter;
  var tips  = ['some description','some other description'];

  // FILTER DROPDOWN 
  $('#filter').val(filter);
  // CALENDAR
  $( ".main-calendar" ).datepicker({
    dateFormat: 'yy-mm-dd',
    showOtherMonths: true,
    showMonth: true,
    defaultDate: date1,
    // beforeShowDay: highlightDays,
    onSelect: function(dateText, inst) {
      var beg = dateText;
      var end = dateText;
      if ( filter == 'daily' ) {
      } else if ( filter == 'weekly' ) { 
        beg = dateText.startOfWeek();
        end = dateText.endOfWeek();
      } else if ( filter == 'bi-weekly' ) {
        beg = dateText.startOfWeek();
        end = dateText.endOfNextWeek();
      } else if ( filter == 'monthly' ) {
        beg = dateText.startOfMonth();
        end = dateText.endOfMonth();
      }

      window.location = '/' + $('#filter').val() + '/shifts/' + beg + '/' + end;
    }
  });
  
  function highlightDays(calendarDate) {
    // between months (start)
    if ( date1.getMonth() < calendarDate.getMonth() && date2.getMonth() == calendarDate.getMonth() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', tips[i]];
    }
    // between months (end )
    else if ( date2.getMonth() > calendarDate.getMonth() && date1.getMonth() == calendarDate.getMonth() && calendarDate.getDate() >= date1.getDate() ) {
      return [true, 'highlight', tips[i]];
    }
    // regular test
    else if ( date1.getMonth() == date2.getMonth() && calendarDate.getDate() >= date1.getDate() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', tips[i]];
    }
  }

  // ********* AJAX *********
  $('.shift-table .delete').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $.ajax( {
      type: 'delete',
      url: $(this).attr('href'),
      data: { },
      dataType: 'json',
      error: function() {
        alert('error');
      },
      success: function(json) {
        $('tr[data-shift-id="' + json.id + '"]').children('td').effect('highlight', {color: 'hsl(0, 66%, 76%)'}, 700, function() {
          $(this).remove();
        });
      }
    });

  });
    
  // ********* STYLING *********
  // change data attr so that hover styling can be different
  $('#filter').on('change', function() {
    $('.main-calendar').attr('data-filter', $(this).val());
  });
  // bi-weekly hover styling 
  $('.main-calendar td').hover( function() {
    $(this).closest('tr').find('a, span').addClass('hover-style');
    $(this).closest('tr').next().find('a, span').addClass('hover-style');
  }, function() {
    $(this).closest('tr').find('a, span').removeClass('hover-style');
    $(this).closest('tr').next().find('a, span').removeClass('hover-style');
  });

  // ****** BY-PAGE ******
  $( ".shifts-edit .daily" ).on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    var editPath = '/daily/shifts/' + $("#shift_date_in").val() + '/'+ $("#shift_date_in").val() ;
    window.location = editPath;
  });
});