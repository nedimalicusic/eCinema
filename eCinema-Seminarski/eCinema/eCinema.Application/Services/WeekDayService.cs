using AutoMapper;
using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using FluentValidation;

namespace eCinema.Application.Services
{
    public class WeekDayService : BaseService<WeekDay, WeekDayDto, WeekDayUpsertDto, BaseSearchObject, IWeekDayRepository>, IWeekDayService
    {
        public WeekDayService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<WeekDayUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
