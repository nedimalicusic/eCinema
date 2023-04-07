using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class SeatsService : BaseService<Seat, SeatDto, SeatUpsertDto, BaseSearchObject, ISeatsRepository>, ISeatsService
    {
        public SeatsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<SeatUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
