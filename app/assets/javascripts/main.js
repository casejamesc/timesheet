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
  //javascript creates a local version of datetimes on creation (6 hours behind UTC)
  Date.prototype.correct = function() {
    this.setHours(this.getHours() + 6);
  };
  Date.prototype.format = function() {
     return '' + this.getFullYear() + '-' + (this.getMonth() + 1) + '-' + this.getDate() + '';
  };

  // ********* INITIALIZATION *********
  if (typeof gon != "undefined") {
    var date1 = new Date(gon.date1);
    var date2 = new Date(gon.date2);
    var filter = gon.filter;

    date1.correct();
    date2.correct();
    $('#filter').val(filter);
  }

  // FILTER DROPDOWN 
  $('#filter').on('change', function() {
    filter = $(this).val();
    $('.main-calendar').attr('data-filter', $(this).val());
  });
  // CALENDAR
  if ( $('.main-calendar').length ) {
    $(".main-calendar").datepicker({
      dateFormat: 'yy-mm-dd',
      showOtherMonths: true,
      showMonth: true,
      defaultDate: date1,
      beforeShowDay: highlightDays,
      onSelect: function(dateText, inst) {
        var beg = new Date(dateText);
        var end = new Date(dateText);

        beg.correct();
        end.correct();

        switch (filter) {
          case 'daily':
          break;
          case 'weekly':
          beg = beg.startOfWeek();
          end = end.endOfWeek();
          break;
          case 'bi-weekly':
          beg = beg.startOfWeek();
          end = end.endOfNextWeek();
          break;
          case 'monthly':
          beg = beg.startOfMonth();
          end = end.endOfMonth();
          break;
        }
        
        window.location = '/' + $('#filter').val() + '/shifts/' + beg.format() + '/' + end.format();
      }
    });
  }
  
  function highlightDays(calendarDate) {
    // between months (start)
    if ( date1.getMonth() < calendarDate.getMonth() && date2.getMonth() === calendarDate.getMonth() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', ''];
    }
    // between months (end )
    else if ( date2.getMonth() > calendarDate.getMonth() && date1.getMonth() === calendarDate.getMonth() && calendarDate.getDate() >= date1.getDate() ) {
      return [true, 'highlight', ''];
    }
    // regular test
    else if ( date1.getMonth() == date2.getMonth() && calendarDate.getDate() >= date1.getDate() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', ''];
    }
    return [true, '', ''];
  }

  // ********* AJAX *********
  // CREATE
  $('.new_task').on('submit', function(e) {
    //set project-id on task befor submitting
    projectId = $('.projects-table tr.active').data('id');
    $('#task_project_id').val( projectId );
  });

  // DELETE
  $('.table').on('click', '.delete', function(e) {
    e.preventDefault();
    e.stopPropagation();

    //save table and item
    table = $(this).closest('table');
    itemId = $(this).closest('tr').data('id');
    $.ajax( {
      type: 'delete',
      url: $(this).attr('href'),
      data: { },
      dataType: 'json',
      error: function() {
        alert('error');
      },
      success: function(json) {
        if ( table.hasClass('projects-table') ) {
          //remove tasks of this project
          $('.tasks-table tbody tr[data-project-id="' + itemId + '"]').remove();
          //change active row to all projects
          $('.all-projects').trigger('click');
        }
        // remove row
        itemToDelete = table.find('tr[data-id="' + json.id + '"]');
        itemToDelete.children('td').effect('highlight', {color: 'hsl(0, 66%, 76%)'}, 400, function() {
          itemToDelete.remove();
          displayNoTasksMessage();
        });
      }
    });
  });
  // UPDATE TASKS
  $('#shift_project_id').on('change', function(e) {
    selectedProjectId = $(this).val();
    $.ajax( {
      type: 'get',
      url: '/shifts/retreive_tasks',
      data: { 'selected_project_id': selectedProjectId },
      dataType: 'script',
      error: function() {
        alert('error');
      }
    });
  });

  // ********* STYLING *********
  // bi-weekly hover styling 
  $('.main-calendar td').hover( function() {
    $(this).closest('tr').find('a, span').addClass('hover-style');
    $(this).closest('tr').next().find('a, span').addClass('hover-style');
  }, function() {
    $(this).closest('tr').find('a, span').removeClass('hover-style');
    $(this).closest('tr').next().find('a, span').removeClass('hover-style');
  });

  // ********* BY-PAGE *********
  $( ".shifts-edit .daily" ).on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    var editPath = '/daily/shifts/' + $("#shift_date_in").val() + '/'+ $("#shift_date_in").val();
    window.location = editPath;
  });

  // *** PROJECTS/TASKS INDEX ***
  function displayNoTasksMessage() {
    // display text for no tasks
    if ( $('.tasks-table tbody').height() > 0 ) {
      $('.no-tasks').addClass('hide');
    } else {
      $('.no-tasks').removeClass('hide');
    }
  }

  $('.projects-table tbody').on('click', 'tr', function() {
    // display tasks by project
    $('.projects-table tbody tr').removeClass('active');
    $(this).addClass('active');
    if ( $(this).data('id') == '-1' ) {
      $('.new_task .new').prop('disabled', true);
      $('.tasks-table tbody tr').removeClass('hide');
    } else {
      $('.tasks-table tbody tr').addClass('hide');
      $('.tasks-table tbody tr[data-project-id="' + $(this).data('id') + '"]').removeClass('hide');
      $('.new_task .new').prop('disabled', false);
    }
    displayNoTasksMessage();
  });
  // DISABLE TASKS NEW BUTTON 
  $('.all-projects').trigger('click');
});