using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class ShowSeatsService : BaseService<ShowSeat, ShowSeatDto, ShowSeatUpsertDto, BaseSearchObject, IShowSeatsRepository>, IShowSeatsService
    {
        public ShowSeatsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ShowSeatUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
