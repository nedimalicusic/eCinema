using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Core.Dtos.Cinema;
using System.Text.RegularExpressions;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class CinemasService : BaseService<Cinema, CinemaDto, CinemaUpsertDto, CinemaSearchObject, ICinemasRepository>, ICinemasService
    {
        public CinemasService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CinemaUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task<DashboardDto> GetDashboardInformation(int cinemaId, CancellationToken cancellationToken)
        {
            var countOfUsers = UnitOfWork.UsersRepository.getCountOfUsers(cancellationToken);
            var countOfUsersActive = UnitOfWork.UsersRepository.getCountOfUsersActive(cinemaId,cancellationToken);
            var countOfUsersInActive = UnitOfWork.UsersRepository.getCountOfUsersInactive(cinemaId, cancellationToken);
            var countOfEmployees = UnitOfWork.EmployeesRepository.getCountOfEmployees(cinemaId,cancellationToken);
            var countOfReservation = UnitOfWork.ReservationsRepository.getCountOfReservation(cinemaId, cancellationToken);

            var newDto = new DashboardDto
            {
                countUsers = countOfUsers,
                countUsersActive = countOfUsersActive,
                countUsersInActive = countOfUsersInActive,
                countEmployees = countOfEmployees,
                countOfReservation = countOfReservation,
            };
            return newDto;

        }
    }
}
